// Copy generated md outputs to spec-compliant `.html.md` names (see the Proposal section in index.qmd).
const dir = Deno.env.get("QUARTO_PROJECT_OUTPUT_DIR")!;
for await (const f of Deno.readDir(dir)) {
  if (!f.name.endsWith(".md") || f.name.endsWith(".html.md") || f.name === "README.md") continue;
  const dst = `${dir}/${f.name.replace(/(-commonmark)?\.md$/, ".html.md")}`;
  try { await Deno.stat(dst); } catch { await Deno.copyFile(`${dir}/${f.name}`, dst); }
}
