from docx import Document

def inspect_docx(filename):
    try:
        doc = Document(filename)
        print(f"Structure of {filename}:")
        for para in doc.paragraphs:
            if para.text.strip():
                # Print text with style to identify headings
                print(f"[{para.style.name}] {para.text[:100]}...")
    except Exception as e:
        print(f"Error reading docx: {e}")

if __name__ == "__main__":
    inspect_docx("EXP5.docx")
