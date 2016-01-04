module ApplicationHelper
  def present(model)
    obj = "#{model.class}Presenter".constantize
    presenter = obj.new(model,self)
  end
end
