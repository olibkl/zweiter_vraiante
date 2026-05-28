import { createBrowserRouter } from "react-router-dom";
import { AppLayout } from "@/pages/_layout";
import Overview from "@/pages/overview";
import NotFoundPage from "@/pages/not-found";
import Setup from "@/pages/setup";
import Workspace from "@/pages/workspace";

// Support for GitHub Pages and dev server redirect
if (window.location.pathname.endsWith("/index.html")) {
  const newPath = window.location.pathname.replace(/\/index\.html$/, "") || "/";
  window.history.replaceState(
    null,
    "",
    newPath + window.location.search + window.location.hash,
  );
}

export const router = createBrowserRouter([
  {
    path: "/",
    element: <AppLayout showHeader={true} />,
    errorElement: <NotFoundPage />,
    children: [
      {
        index: true,
        element: <Overview />,
      },
      {
        path: "setup",
        element: <Setup />,
      },
      {
        path: "workspace/:planId",
        element: <Workspace />,
      },
    ],
  },
]);
