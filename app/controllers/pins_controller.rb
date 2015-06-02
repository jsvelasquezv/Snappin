class PinsController < ApplicationController
	before_action :find_pin, only: [:show, :edit, :update, :destroy, :upvote]
	before_action :authenticate_user!, except: [:index, :show]

	add_breadcrumb I18n.t("layouts.application.title"), :root_path

	def index
		#@pins = Pin.all.order("created_at DESC")
		if params[:search]
			@pins = Pin.search(params[:search]).order("created_at DESC")
		else
			@pins = Pin.all.order("created_at DESC")
		end
	end

	def new
		@pin = current_user.pins.build
		add_breadcrumb I18n.t("layouts.application.newPin")
	end

	def create
		@pin = current_user.pins.build(pin_params)

		if @pin.save
			redirect_to @pin, notice: "Pin creado correctamente"
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @pin.update(pin_params)
			redirect_to @pin, notice: "Pin modificado correctamente"			
		else
			render 'edit'
		end
	end

	def destroy
		@pin.destroy
		redirect_to root_path
	end

	def upvote
		@pin.upvote_by current_user
		redirect_to :back
	end

	private

	def pin_params
		params.require(:pin).permit(:title, :description, :image)
	end

	def find_pin
		@pin = Pin.find(params[:id])
	end
end
