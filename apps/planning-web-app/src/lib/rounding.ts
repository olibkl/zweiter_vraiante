import type { PlanningRoundingMode } from "@/types/planning";

export const DEFAULT_ROUNDING_MODE: PlanningRoundingMode = "commercial";
export const DEFAULT_MONEY_PRECISION = 2;
export const DEFAULT_PHYSICAL_PRECISION = 3;

export const roundByMode = (
  value: number,
  mode: PlanningRoundingMode,
  precision: number,
) => {
  const factor = 10 ** precision;
  const scaled = value * factor;
  if (mode === "up") return Math.ceil(scaled) / factor;
  if (mode === "down") return Math.floor(scaled) / factor;
  if (mode === "symmetric") {
    return (Math.sign(scaled) * Math.floor(Math.abs(scaled) + 0.5)) / factor;
  }
  return Math.round(scaled) / factor;
};

export const roundNonNegative = (
  value: number,
  mode: PlanningRoundingMode,
  precision: number,
) => Math.max(0, roundByMode(value, mode, precision));
