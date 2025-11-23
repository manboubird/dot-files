# GenAI CLI

`genai-cli` is a command-line tool for managing and rendering generative AI prompts. It supports Jinja2 templates and YAML definitions, allowing for organized and reusable prompt management.

## Features

- **Prompt Management**: Organize prompts in `.j2` (Jinja2) or `.yml` (YAML) files.
- **Template Rendering**: Render prompts with dynamic variables.
- **Interactive Mode**: Interactively input missing variables.
- **Default Values**: Define default values for variables directly in templates.
- **REPL**: Interactive shell with auto-completion and reload capabilities.
- **Export**: Export all prompts to a CSV file.

## Usage

### Listing Prompts

List all available prompts. Use `--detail` to see parameters and their default values.

```bash
# Simple list
genai-cli list

# Detailed list with parameters and defaults
genai-cli list --detail
```

**Output Example:**
```text
[1] business/strategy/pest_analysis
    Description: Perform a PEST analysis.
    Parameters: company_name (default: Acme Corp)
```

### Rendering Prompts

Render a prompt by its key or number. You can provide context variables via command line arguments or use interactive mode.

```bash
# Render using default values (if defined)
genai-cli render 1

# Render with specific context variables
genai-cli render business/strategy/swot_analysis --context company_name="My Startup"

# Interactive mode (prompts for missing variables)
genai-cli render 1 --interactive
```

### Inspecting Prompts

View the parameters required by a specific prompt.

```bash
genai-cli inspect business/strategy/swot_analysis
```

### REPL (Interactive Shell)

Start the interactive shell for a smoother workflow.

```bash
genai-cli repl
```

**REPL Commands:**
- `list`: List prompts.
- `render <key/number>`: Render a prompt.
- `reload`: Reload all prompt files.
- `reload <filename>`: Reload a specific file (e.g., `reload prompts/examples/strategy.yml`).
- `exit`: Exit the REPL.

### Exporting Prompts

Export all prompts to a CSV file for analysis or external use.

```bash
# Export to current directory (prompts_export.csv)
genai-cli export

# Export to a specific directory
genai-cli export --output ./exports
```

## Defining Prompts

### Jinja2 Files (`.j2`)
Place `.j2` files in the `prompts` directory. The file path relative to `prompts` becomes the key.

**Example (`prompts/examples/my_prompt.j2`):**
```jinja2
{% set name = name | default('User') %}
Hello, {{ name }}!
```

### YAML Files (`.yml`)
Define multiple prompts in a single YAML file. Supports multi-document YAML.

**Example (`prompts/examples/strategy.yml`):**
```yaml
category_key: "business/strategy"
prompts:
  - name: "swot_analysis"
    description: "Perform a SWOT analysis."
    template: |
      {% set company = company | default('Acme Corp') %}
      Analyze {{ company }}...
```

### Default Values
You can define default values for variables at the top of the template using `{% set %}`:

```jinja2
{% set topic = topic | default('AI') %}
Tell me about {{ topic }}.
```

## References

This project references prompt examples from:
[dahatake/GenerativeAI-Prompt-Sample-Japanese](https://github.com/dahatake/GenerativeAI-Prompt-Sample-Japanese/tree/main)
