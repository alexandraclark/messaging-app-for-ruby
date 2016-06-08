class GuestsController < ApplicationController

  before_action :find_guests_and_events, only: [:new, :edit]

  def find_guests_and_events
    user = User.find_by(id: session[:user_id])
    if user
      guest_status = Guest.find_by(id: user.guest_id)
      if guest_status
        invitations = Invitation.where(guest_id: guest_status.id).pluck("event_id")
        all_invitations = Invitation.where(event_id: invitations).pluck("guest_id")
        @guests = Guest.where(id: all_invitations)
      end
    end

    user = User.find_by(id: session[:user_id])
    if user
      guest_status = Guest.find_by(id: user.guest_id)
      if guest_status
        invitations = Invitation.where(guest_id: guest_status.id).pluck("event_id")
        @events = Event.where(id: invitations)
      end
    end
  end

  def index
    user = User.find_by(id: session[:user_id])
    if user
      guest_status = Guest.find_by(id: user.guest_id)
      if guest_status
        invitations = Invitation.where(guest_id: guest_status.id).pluck("event_id")
        @events = Event.where(id: invitations)
      else
        render 'layouts/no_guests'
      end
    else
      render 'layouts/no_guests'
    end
  end

  def show
    @guest = Guest.find_by(id: params[:id])
    if @guest == nil
      redirect_to guests_url
    end
  end

  def edit
    @guest = Guest.find_by(id: params[:id])
  end

  def update
    @guest = Guest.find(params[:id])

    @guest.first_name = params[:guest][:first_name]
    @guest.last_name = params[:guest][:last_name]
    @guest.email = params[:guest][:email]
    @guest.phone = params[:guest][:phone]

    if @guest.save
      redirect_to guest_url(@guest.id)
    else
      render :edit
    end
  end

  def new
    @event = params[:event_id]
    @guest = Guest.new
    @invitation = Invitation.new
  end

  def create
    @guest = Guest.new
    @guest.first_name = params[:guest][:first_name]
    @guest.last_name = params[:guest][:last_name]
    @guest.email = params[:guest][:email]
    @guest.phone = params[:guest][:phone]

    if @guest.save
    else
      redirect_to new_guest_url, notice: "Something went wrong!"
    end

    @invite = Invitation.new
    @invite.guest_id = @guest.id
    @invite.event_id = params[:invitation][:event_id]
    @invite.RSVP = false
    @invite.attending = false

    if @invite.save
      redirect_to events_url, notice: "Invite sent!"
    else
      render 'new'
    end

  end

  def destroy
    guest = Guest.find_by(id: params[:id])
    if guest
      guest.delete
    end
    redirect_to guests_url
  end

end