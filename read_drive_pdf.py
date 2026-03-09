import PyPDF2

output = 'downloaded.pdf'
with open(output, 'rb') as file:
    reader = PyPDF2.PdfReader(file)
    text = ""
    for page in reader.pages:
         text += page.extract_text() + "\n"
    with open('pdf_content.txt', 'w', encoding='utf-8') as out:
         out.write(text)
