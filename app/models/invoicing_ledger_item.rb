class InvoicingLedgerItem < ActiveRecord::Base

  enum status: [:pending , :paid , :cancelled]
  # acts_as_ledger_item

  validates_date :period_end, :after => :period_start # Method symbol
  # validates_date :due_date, :after => :issue_date # Method symbol
  # validates_date :period_end, :on_or_before => lambda { Date.current }
  # validates_date :period_start, :on_or_before => lambda { Date.current }

  validates_inclusion_of :status, in: statuses.keys

  belongs_to :sender, class_name: 'Admin'
  has_many :line_items, class_name: 'InvoicingLineItem', foreign_key: :ledger_item_id , dependent: :destroy
  has_many :events, through: :line_items

  before_validation :set_currency
  before_validation :set_invoice_period
  before_create :set_identifier
  after_create :set_line_items
  after_create :calculate_net_amount

  accepts_nested_attributes_for :line_items

  default_scope -> {order created_at: :desc}

  def calculate_net_amount
    self.total_amount = events.not_cancelled.sum(:event_cost)
    self.tax_amount   = 0.0
    self.save!
  end


  private

  def set_invoice_period
      self.period_start = self.period_start.beginning_of_month
      self.period_end = self.period_start.end_of_month
  end

  def set_identifier
    self.identifier = SecureRandom.hex(5)
  end

  def set_line_items
    _events = recipient.events.not_cancelled.where("created_at >= ? and created_at <= ? " , period_start , period_end)
    _events.each do |event|
      self.line_items.create({event_id: event.id})
    end
  end
  def set_currency
    self.currency ='£'
  end


end