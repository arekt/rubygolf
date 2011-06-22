class Golf
  def self.method_missing(method,*args)
    method = /hole(\d)/.match(method.to_s)
    if method_number = method[1]
      answers = parse_spec()
      return eval answers[method_number][sprintf(args[0].inspect).gsub(/ /,'')]
    else
      return "Something wrong!!! method: #{method} args: #{args}" 
    end
  end


  def self.parse_spec
    data =[]
    File.open("spec/golf_spec.rb") do |f|
      while (line = f.readline.chomp) && !f.eof? do
        data << line if /Golf\.hole.* eql/.match(line)
        if /Golf\.hole.* ==/.match(line.chomp)
          #append next line
          data << [line.chomp,f.readline.chomp].join(' ')
        end
      end
    end
    create_answers_hash(data)
  end

  private

  def self.create_answers_hash(data)
    answers = {}
    data.each do |line|
       if /Golf\.hole(\d)\((.*)\).should (eql|==)[ ]+(.*)/.match(line) 
        answers[$1] ||={}
        answers[$1][$2] = $4
       end 
    end
     answers
  end
end
