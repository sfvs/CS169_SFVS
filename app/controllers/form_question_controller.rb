class FormQuestionController < ApplicationController

  def show
  	@response = params[:type]
  end

end
