/**
* I convert HTML or RTF to plain text
*/
component singleton="true"{

	PlainTextConvertor function init(){

		// Plugin Properties
		setPluginName("PlainTextConvertor");
		setPluginVersion("1.0");
		setPluginDescription("I convert HTML or RTF to plain text");
		setPluginAuthor("Curt Gratz/Ernst van der Linden");
		setPluginAuthorURL("http://www.compknowhow.com / http://evdlinden.behindthe.net");

		return this;
	}

	public function convert(string text="",string format="html") {
		if (arguments.format=="html") {
			return getPlainTextFromHTML(arguments.text);
		} else {
			return getPlainTextFromRichText(arguments.text);
		}
	}

	private function getPlainTextFromHTML(html) {
		var HTMLEditorKit = CreateObject("java","javax.swing.text.html.HTMLEditorKit").init();
		var styledDocument = CreateObject("java","javax.swing.text.html.HTMLDocument").init();
		var reader = CreateObject("java","java.io.StringReader").init(arguments.html);

		HTMLEditorKit.read(reader,styledDocument,0);
		return styledDocument.getText(0,styledDocument.getLength());
	}

	private function getPlainTextFromRichText(richText) {
		var RTFEditorKit = CreateObject("java","javax.swing.text.rtf.RTFEditorKit").init();
		var styledDocument = CreateObject("java","javax.swing.text.DefaultStyledDocument").init();
		var reader = CreateObject("java","java.io.StringReader").init(arguments.richText);

		RTFEditorKit.read(reader,styledDocument,0);
		return styledDocument.getText(0,styledDocument.getLength());
	}

}
