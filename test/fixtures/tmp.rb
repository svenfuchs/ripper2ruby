  def _evaluate_condition(condition)
    case condition
    when Symbol : self.send(condition)
    when Proc : self.instance_eval(&condition)
    else
      raise ArgumentError,
            'Filter condtions need to be either a Symbol or a Proc'
    end
  end


