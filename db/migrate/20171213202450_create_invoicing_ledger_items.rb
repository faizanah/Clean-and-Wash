class CreateInvoicingLedgerItems < ActiveRecord::Migration
  def change
    create_table :invoicing_ledger_items do |t|
      t.references :sender
      t.references :recipient

      t.string   :type
      t.datetime :issue_date
      t.string   :currency,      limit: 3, null: false
      t.decimal  :total_amount,  precision: 20, scale: 4
      t.decimal  :tax_amount,    precision: 20, scale: 4
      t.integer  :status,        default: 0

      t.string   :identifier,    limit: 50
      t.string   :description
      t.datetime :period_start
      t.datetime :period_end
      t.datetime :due_date

      t.timestamps
    end
  end
end
