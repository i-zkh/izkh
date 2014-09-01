#!/bin/env ruby
# encoding: utf-8
require 'prawn'

class Receipt

  def initialize(date, transaction_id, amount, commission, total, pay_type, vendor_title, card, uin, sum_uin, phone, order_id, fio)
    generate_file(date, transaction_id, amount, commission, total, pay_type, vendor_title, card, uin, sum_uin, phone, order_id, fio)
  end

  private

  def generate_file(date, transaction_id, amount, commission, total, pay_type, vendor_title, card, uin, sum_uin, phone, order_id, fio)
    pdf = Prawn::Document.new(:page_size => [300, 600], :margin => [15])
    pdf.font(Rails.root.join("app/assets/fonts/verdana.ttf"))
    pdf.font_size 10
    pdf.text "HКО \"МОНЕТА.РУ\" (OOO)", :align => :center
    pdf.text "424000, Российская Федерация,", :align => :center
    pdf.text "Республика Марий Эл, г. Йошкар-Ола", :align => :center
    pdf.text "ул. Гоголя, д. 2, строение \"А\"", :align => :center
    pdf.text "тел./факс: 8(495)743-49-85,", :align => :center
    pdf.text "e-mail: helpdesk.support@moneta.ru", :align => :center
    pdf.move_down(5)
    pdf.stroke_horizontal_rule
    pdf.pad(10) {  pdf.text "Квитанция об оплате", :align => :center }
    pdf.stroke_horizontal_rule
    pdf.move_down(5)
    pdf.text "Номер операции: #{transaction_id}"
    pdf.text "Дата и время: #{date}"
    pdf.move_down(15)
    pdf.text "Сумма платежа: #{total} RUB" 
    pdf.text "В том числе комиссия: #{commission} RUB"
    pdf.move_down(15)
    pdf.text "Реквизиты плательщика:"
    pdf.text "Номер карты: #{card}"
    pdf.move_down(5)
    pdf.stroke_horizontal_rule
    pdf.move_down(5)
    pdf.text "Вид платежа: оплата штрафоф ГИБДД"
    pdf.text "Наименование платежа: ШТРАФ ПО АДМИНИСТРАТИВНОМУ ПРАВОНАРУШЕНИЮ ПОСТАНОВЛЕНИЕ"
    pdf.text "#{uin}"
    pdf.text "Сумма штрафа: #{sum_uin}"
    pdf.text "Комиссия: #{commission}"
    pdf.text "Параметры платежа"
    pdf.text "Контактный телефон плательщика: #{phone}"
    pdf.text "Идентификатор платежа: #{order_id}"
    pdf.text "ФИО плательщика: #{fio}"
    pdf.text "КБК 18811630020016000140"
    pdf.text "Получатель УФК г.Москвы (УГИБДД ГУ МВД России по г.Москве (ЦАФАП). л/сч № 04731440640)"
    pdf.text "КПП 770731005; ИНН 7707089101"
    pdf.text "Счет 40101810800000010041"
    pdf.text "Банк в Отделение 1 Москва"
    pdf.text "БИК 044583001"
    pdf.move_down(5)
    pdf.stroke_horizontal_rule
    pdf.move_down(5)
    pdf.image Rails.root.join("app/assets/images/receipe.png"), :width => 270, :height => 50, :align => :center
    pdf.move_down(5)
    pdf.text "По претензиям, связанным со списанием средств со счета, Вы можете направить заявление по электронной почте", :align => :center
    pdf.move_down(5)
    pdf.text "По вопросу предоставления услуги обращайтесь к получателю платежа", :align => :center
    pdf.render_file "#{Time.now.strftime('%Y-%m-%d')}.pdf"  
  end

  def jkh_file(date, transaction_id, amount, commission, total, pay_type, vendor_title, card)
    pdf = Prawn::Document.new(:page_size => [300, 500], :margin => [15])
    pdf.font(Rails.root.join("app/assets/fonts/verdana.ttf"))
    pdf.font_size 10
    pdf.text "HКО \"МОНЕТА.РУ\" (OOO)", :align => :center
    pdf.text "424000, Российская Федерация,", :align => :center
    pdf.text "Республика Марий Эл, г. Йошкар-Ола", :align => :center
    pdf.text "ул. Гоголя, д. 2, строение \"А\"", :align => :center
    pdf.text "тел./факс: 8(495)743-49-85,", :align => :center
    pdf.text "e-mail: helpdesk.support@moneta.ru", :align => :center
    pdf.move_down(5)
    pdf.stroke_horizontal_rule
    pdf.pad(10) {  pdf.text "Квитанция об оплате", :align => :center }
    pdf.stroke_horizontal_rule
    pdf.move_down(5)
    pdf.text "Дата: #{date}"
    pdf.text "Номер операции: #{transaction_id}"
    pdf.move_down(5)
    pdf.text "Сумма: #{amount}"
    pdf.text "Комиссия: #{commission}"
    pdf.text "Итого: #{total}"
    pdf.move_down(5)
    pdf.text "Плательщик: #{pay_type}"
    pdf.move_down(5)
    pdf.text "Реквизиты плательщика:"
    pdf.text "Последние цифры номера карты: #{card}"
    pdf.move_down(5)
    pdf.text "Получатель: #{vendor_title}"
    pdf.move_down(5)
    pdf.image Rails.root.join("app/assets/images/receipe.png"), :width => 250, :height => 50, :align => :center
    pdf.move_down(5)
    pdf.text "По претензиям, связанным со списанием средств со счета, Вы можете направить заявление по электронной почте", :align => :center
    pdf.move_down(5)
    pdf.text "По вопросу предоставления услуги обращайтесь к получателю платежа", :align => :center
    pdf.render_file "#{Time.now.strftime('%Y-%m-%d')}.pdf"    
  end

end