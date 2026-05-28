import { expect, test } from "@playwright/test";

test("workspace shell renders core controls", async ({ page }) => {
  await page.goto("/workspace/PLAN-2026-001");
  await expect(page.getByText("Planungslogik")).toBeVisible();
  await expect(page.getByRole("button", { name: "Aktualisieren" })).toBeVisible();
});

test("edit -> aktualisieren -> reload keeps values", async ({ page }) => {
  await page.goto("/workspace/PLAN-2026-001");

  const firstRow = page.locator("tbody tr").first();
  const percentPlanInput = firstRow.locator('input[type="text"]').nth(1);

  await percentPlanInput.click();
  await percentPlanInput.fill("99");
  await percentPlanInput.press("Enter");

  const applyButton = page.getByRole("button", { name: "Aktualisieren" });
  await expect(applyButton).toBeEnabled();
  await applyButton.click();

  await expect(page.getByText("Änderungen wurden übernommen.")).toBeVisible();

  await page.reload();
  await expect(firstRow.locator('input[type="text"]').nth(1)).toHaveValue(/99/);
});
