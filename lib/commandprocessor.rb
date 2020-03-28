class CommandProcessor

  def self.process(command)
    begin
      return send(command)+"\n"
    rescue NoMethodError
      # NOTE:
      # Since there was no instructions on what to do in case of
      # an invalid command I've elected to return an error message
      return "ERROR: Invalid command\n"
    end
  end

  def self.date
    return Time.now.strftime("%F")
  end

  def self.time
    return Time.now.strftime("%T%:z")
  end

  def self.datetime
    return Time.now.strftime("%FT%T%:z")
  end
end
