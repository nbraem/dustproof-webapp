class IncomingMessagesController < ApplicationController
  before_action :require_admin
  before_action :set_incoming_message, only: [:show, :destroy]
  respond_to :html
  add_breadcrumb :index, :incoming_messages_path

  def index
    @q = IncomingMessage.search(params[:q])
    @q.sorts = "created_at desc" if @q.sorts.empty?
    @incoming_messages = @q.result(distinct: true).page(params[:page])
    respond_with(@incoming_messages)
  end

  def show
    add_breadcrumb @incoming_message.id.to_s
    respond_with(@incoming_message)
  end

  def destroy
    @incoming_message.destroy
    respond_with(@incoming_message)
  end

  def destroy_all
    IncomingMessage.destroy_all
    redirect_to :incoming_messages, notice: "Destroyed all incoming messages."
  end

  private

  def set_incoming_message
    @incoming_message = IncomingMessage.find(params[:id])
  end
end
