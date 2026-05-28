import { createRemoteJWKSet, jwtVerify } from "jose";

const DEV_ROLE_HEADER = "x-dev-role";
const DEV_USER_HEADER = "x-dev-user";

const parseRoles = (value) =>
  String(value ?? "")
    .split(",")
    .map((role) => role.trim())
    .filter(Boolean);

export const authMiddleware = async (req, res, next) => {
  const mode = process.env.AUTH_MODE ?? "dev";

  if (mode === "dev") {
    const roles = parseRoles(req.header(DEV_ROLE_HEADER) ?? "Planner");
    req.user = {
      id: req.header(DEV_USER_HEADER) ?? "local-dev-user",
      roles,
      authMode: "dev",
    };
    return next();
  }

  try {
    const issuer = process.env.AZURE_AD_ISSUER;
    const audience = process.env.AZURE_AD_AUDIENCE;
    if (!issuer || !audience) {
      return res.status(500).json({
        error: "AUTH_CONFIG_MISSING",
        message: "AZURE_AD_ISSUER und AZURE_AD_AUDIENCE sind erforderlich.",
      });
    }

    const authHeader = req.header("authorization");
    if (!authHeader?.startsWith("Bearer ")) {
      return res.status(401).json({ error: "UNAUTHORIZED", message: "Bearer-Token fehlt." });
    }

    const token = authHeader.slice("Bearer ".length);
    const jwks = createRemoteJWKSet(new URL(`${issuer}/discovery/v2.0/keys`));
    const { payload } = await jwtVerify(token, jwks, { issuer, audience });
    const roles = Array.isArray(payload.roles) ? payload.roles.map(String) : [];
    req.user = {
      id: String(payload.oid ?? payload.sub ?? "unknown-user"),
      roles,
      authMode: "azure",
    };
    return next();
  } catch {
    return res.status(401).json({ error: "UNAUTHORIZED", message: "Token ungültig." });
  }
};

export const requireAnyRole = (...requiredRoles) => (req, res, next) => {
  const userRoles = req.user?.roles ?? [];
  if (requiredRoles.some((role) => userRoles.includes(role))) {
    return next();
  }
  return res.status(403).json({
    error: "FORBIDDEN",
    message: `Erforderliche Rollen: ${requiredRoles.join(", ")}`,
  });
};

