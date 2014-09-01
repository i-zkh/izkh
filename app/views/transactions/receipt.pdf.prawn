pdf = Prawn::Document.new
pdf.font_families.update("Verdana" => {:normal  => "fonts/7fonts.ru_Verdankz.ttf" })
pdf.font "Verdana"
pdf.text "HКО \"МОНЕТА.РУ\" (OOO)", :align => :center
pdf.text "424000, Российская Федерация,", :align => :center
pdf.render_file "#{Time.now.strftime('%Y-%m-%d')}.pdf"  
pdf.move_down(1)
pdf.render_file "#{Time.now.strftime('%Y-%m-%d')}.pdf"  