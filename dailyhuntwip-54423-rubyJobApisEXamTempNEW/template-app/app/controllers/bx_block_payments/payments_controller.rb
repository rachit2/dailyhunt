module BxBlockPayments
	class PaymentsController < ApplicationController

		def create
			payment = current_user.payments.new(payment_params)
			payment.price = payment.course_order.price
			payment.status = 'paid'
			if payment.save
				render json: BxBlockPayments::PaymentSerializer.new(payment).serializable_hash, status: :ok
			else
				render json: {errors: payment.errors}
			end
		end

		private

	  def payment_params
	    params.require(:data).permit \
	      :course_order_id,
	      :price,
	      :status
	  end

	end
end
