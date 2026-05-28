import { NavLink, Outlet, useLocation, useNavigate } from "react-router-dom";
import { ProfileDropdown } from "@/components/ProfileDropdown";

type AppLayoutProps = { showHeader?: boolean };

export function AppLayout({ showHeader = true }: AppLayoutProps) {
  const location = useLocation();
  const navigate = useNavigate();

  const handleOverviewPointerDown = (
    event: React.PointerEvent<HTMLAnchorElement>,
  ) => {
    if (event.button !== 0) {
      return;
    }

    if (event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) {
      return;
    }

    if (location.pathname === "/") {
      return;
    }

    event.preventDefault();
    navigate("/");
  };

  return (
    <div className="min-h-dvh flex flex-col">
      {showHeader && (
        <header className="relative z-40 h-14 border-b flex items-center bg-background">
          <div className="mx-auto flex w-full items-center justify-between px-6">
            <nav className="flex items-center gap-4">
              <NavLink
                to="/"
                end
                onPointerDown={handleOverviewPointerDown}
                className="inline-flex h-9 items-center rounded-md text-sm text-muted-foreground transition-transform hover:scale-95 focus-visible:scale-95 cursor-pointer"
              >
                Overview
              </NavLink>
            </nav>
            <div className="flex items-center gap-2">
              <ProfileDropdown />
            </div>
          </div>
        </header>
      )}

      <main className="flex-1 flex py-6">
        <div className="mx-auto w-full flex-1 px-6">
          <Outlet />
        </div>
      </main>
    </div>
  );
}
