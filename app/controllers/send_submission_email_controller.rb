# frozen_string_literal: true

class SendSubmissionEmailController < ApplicationController
  layout 'flow'

  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def success; end

  def create
    @submission =
      if params[:flow_slug]
        Submission.joins(:flow).find_by!(email: params[:email], flow: { slug: params[:flow_slug] })
      else
        Submission.find_by!(slug: params[:submission_slug])
      end

    SubmissionMailer.copy_to_submitter(@submission).deliver_later!

    respond_to do |f|
      f.html { redirect_to success_send_submission_email_index_path }
      f.json { head :ok }
    end
  end
end