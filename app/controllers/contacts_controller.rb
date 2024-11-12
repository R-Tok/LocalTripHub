class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def confirm
    @contact = Contact.new(contact_params)
    if @contact.valid?
      session[:contact_token] = SecureRandom.hex(10)
      render :confirm
    else
      flash.now[:danger] = t("contacts.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def create
    @contact = Contact.new(contact_params)

    if params[:back]
      render :new
    elsif @contact.save
      ContactMailer.send_email(@contact).deliver_now
      redirect_to done_contacts_path
    else
      flash.now[:danger] = t("contacts.create.failure")
      render :new, status: :unprocessable_entity, data: { turbo: false }
    end
  end

  def done; end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message)
  end
end
