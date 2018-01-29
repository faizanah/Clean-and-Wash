class InvoiceDecorator < ApplicationDecorator
  delegate_all
  decorates_association :recipient
  decorates_association :line_items

  def delete_button_link
    h.link_to 'Delete', [:admin , self], class: 'btn btn-primary',method: :delete , remote: true
  end

  def save_link
    h.link_to 'Save', [:admin , self], class: 'btn btn-primary',method: :put
  end

  def formatted_net_amount
    amount_in_currency(object.total_amount)
  end

  def formatted_tax_amount
    amount_in_currency(object.tax_amount)
  end
  def formatted_total_amount
    amount_in_currency(object.total_amount)
  end
  def invoice_no
    h.content_tag(:h3 , "INVOICE NO. # JSC-#{object.id }")
  end
  def formatted_issue_date
    object.issue_date.present? ? object.issue_date.strftime('%B %d, %Y') : '-'
  end

  def formatted_due_date
    object.due_date.present? ? object.due_date.strftime('%d %B %Y') : '-'
  end

  def download_link
    h.link_to 'Print', h.admin_invoice_path(self), class: 'btn btn-primary' , target: "_blank"
  end

  def download_button
    h.link_to h.content_tag(:i , '' , class: 'entypo-download'), h.admin_invoice_download_path(self), class: 'btn btn-primary' , method: :post
  end

  def preview_button
    h.link_to "Preview", h.admin_invoice_path(self), class: 'btn btn-default'
  end

  def updated_button
    h.link_to "Save Changes",[:admin , self], class: 'btn btn-primary' , method: :put
  end

  def pdf_download_name
    "JCS-#{object.id} - #{invoice.recipient.full_name} - #{invoice.issue_date.strftime("%B %d, %Y")}.pdf"
  end

  def previous_balance
    amount_in_currency(0.0)
  end

  def modal_form
    h.render 'backend/admin/invoices/partials/modal' , invoice: self
  end

  def row
    h.render 'backend/admin/invoices/partials/table_row' , invoice: self
  end

end