import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Button } from "@/components/ui/button";

export const demoUser = {
  name: "Demo Workspace",
  email: "offline-mode@planning.local",
};

export function ProfileDropdown() {
  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button
          variant="ghost"
          size="icon"
          aria-label="Workspace info"
          className="!bg-transparent hover:bg-muted/70 !rounded-full focus-visible:!ring-2 focus-visible:!ring-ring/50 transition-colors cursor-pointer transform-gpu hover:scale-95"
        >
          <span
            className="flex size-8 select-none items-center justify-center rounded-full border border-border bg-muted font-semibold text-muted-foreground"
            style={{ width: 32, height: 32 }}
          >
            {demoUser.name
              .split(" ")
              .map((n) => n[0])
              .join("")
              .toUpperCase()}
          </span>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-56">
        <div className="px-3 py-2">
          <div className="text-sm font-medium">{demoUser.name}</div>
          <div className="truncate text-xs text-muted-foreground">{demoUser.email}</div>
        </div>
        <DropdownMenuSeparator />
        <DropdownMenuItem disabled>Login nicht erforderlich</DropdownMenuItem>
        <DropdownMenuItem disabled>Azure AD folgt spaeter</DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
