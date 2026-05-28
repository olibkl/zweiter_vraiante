import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";

export default function NotFoundPage() {
  return (
    <div className="min-h-full grid place-items-center">
      <div className="w-full text-center flex flex-col items-center space-y-6">
        <h1 className="text-5xl leading-tight tracking-tight">
          404 – Not found
        </h1>
        <p className="text-muted-foreground">
          This isn't the page you're looking for.
        </p>
        <Button asChild variant="outline">
          <Link to="/">Go overview</Link>
        </Button>
      </div>
    </div>
  );
}
