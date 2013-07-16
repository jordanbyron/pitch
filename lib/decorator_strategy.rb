class DecoratorStrategy < DecentExposure::StrongParametersStrategy
  def resource
    r = super

    if r.respond_to?(:empty?) && r.empty?
      r
    else
      r.class.send(:include, Draper::Decoratable) unless r.respond_to?(:decorate)
      r.decorate
    end
  end
end
