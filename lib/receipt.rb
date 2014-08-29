class Receipt

  def initialize(text)
    generate_file(text)
  end

  private

  def generate_file(text)
    pdf = Prawn::Document.new
    pdf.text "#{text}"
    pdf.render_file "#{Time.now.strftime('%Y-%m-%d')}.pdf"  
  end
end