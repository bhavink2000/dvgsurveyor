const { execSync } = require("child_process");
const axios = require("axios");
const fs = require("fs");

async function run() {
    try {
        console.log("\n🚀 AI Automation Started...\n");

        // 🔹 Get current branch
        const branch = execSync("git rev-parse --abbrev-ref HEAD")
            .toString()
            .trim();

        console.log("🌿 Branch:", branch);

        // 🔹 Skip base branch
        if (branch === "new_develop") {
            console.log("⛔ Skipping base branch");
            return;
        }

        // 🔹 Check if PR already exists
        try {
            execSync(`gh pr view ${branch}`, { stdio: "ignore" });
            console.log("⚠️ PR already exists for this branch");
            return;
        } catch {
            console.log("✅ No existing PR, continuing...");
        }

        // 🔹 Get diff from base branch
        console.log("🔍 Getting diff...");
        const diff = execSync("git diff new_develop", {
            maxBuffer: 1024 * 1024 * 20 // 20MB buffer
        }).toString();

        if (!diff || diff.trim().length === 0) {
            console.log("⚠️ No changes found vs base branch");
            return;
        }

        console.log("🤖 Generating PR + Review using AI...\n");

        // 🔹 Call Ollama (FREE AI)
        const response = await axios.post("http://localhost:11434/api/generate", {
            model: "llama3",
            prompt: `
You are a senior software engineer.

Analyze this git diff and generate a professional Pull Request.

Return in clean format:

### PR Title:
<short title>

### Description:
<detailed explanation>

### Key Changes:
- ...

### Testing Steps:
- ...

### Code Review:
- Bugs
- Improvements
- Risks

Git Diff:
${diff}
`
        });

        const aiOutput = response.data.response;

        // 🔹 Save PR content
        fs.writeFileSync("pr.txt", aiOutput);

        console.log("📄 PR content generated and saved to pr.txt\n");

        // 🔹 Push branch
        console.log("⬆️ Pushing branch...");
        execSync(`git push origin ${branch}`, { stdio: "inherit" });

        // 🔹 Extract PR title (first line after "PR Title:")
        const titleMatch = aiOutput.match(/PR Title:\s*(.*)/i);
        const prTitle = titleMatch ? titleMatch[1] : `Auto PR: ${branch}`;

        // 🔹 Create PR
        console.log("🚀 Creating Pull Request...");
        execSync(
            `gh pr create --base new_develop --head ${branch} --title "${prTitle}" --body-file pr.txt`,
            { stdio: "inherit" }
        );

        console.log("\n✅ PR Created Successfully! \n");

    } catch (err) {
        console.log("\n❌ Error:", err.message);
    }
}

run();