package;

import yaml.Yaml;
import js.Browser;
import js.html.TextAreaElement;

class Main {
	static var textareaIn: TextAreaElement;
	static var textareaOut: TextAreaElement;

	static function main() {
		textareaIn = cast Browser.document.getElementById("in");
		textareaOut = cast Browser.document.getElementById("out");

		convertYaml(textareaIn.value);

		textareaIn.addEventListener('input', () -> {
			convertYaml(textareaIn.value);
		});
	}

	static function convertYaml(from: String) {
		try {
			final data = Yaml.parse(from);
			textareaOut.value = generateGhosttyConfig(data);
			textareaIn.rows = textareaIn.value.split("\n").length;
			textareaOut.rows = textareaOut.value.split("\n").length;
			textareaIn.classList.remove("invalid");
		} catch (e) {
			textareaIn.classList.add("invalid");
		}
	}

	public static function generateGhosttyConfig(scheme: Dynamic): String {
		var buf = new StringBuf();

		// Header
		buf.add('# Scheme: ${scheme.get("scheme")}\n');
		buf.add("# Generated by Ghostty Base16 Converter\n");

		// Background, foreground
		buf.add('background = ${scheme.get("base00")}\n');
		buf.add('foreground = ${scheme.get("base05")}\n\n');

		// Selection
		buf.add('selection-background = ${scheme.get("base02")}\n');
		buf.add('selection-foreground = ${scheme.get("base00")}\n');

		// Palette
		var i = 0;
		for (base in [
			"00", "08", "0B", "0A", "0D", "0E", "0C", "05", "03", "08", "0B",
			"0A", "0D", "0E", "0C", "07", "09", "0F", "01", "02", "04", "06"
		]) {
			buf.add('\npalette = $i=#');
			buf.add(scheme.get("base" + base));
			i++;
		}

		return buf.toString();
	}
}
