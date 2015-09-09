require 'optparse'
require 'optparse/time'
require 'ostruct'

class MatchRules
  def self.parse(args)
    options = OpenStruct.new()

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: ./simplerake.rb [options] srake_file [task]"

      opts.separator ""
      opts.separator "Specific options:"

      opts.on("-T", "list tasks") do |t|
          $has_T=true   #when Input -T,I should do handle some special thing 
      end

      opts.on_tail("-h", "print help") do
        puts opts
        exit
      end
  end
    opt_parser.parse!(args)
    options
  end  # parse()

  def initialize
    options = self.class.parse(ARGV)
    @depend_1 = {}
    @depend_2 = {}
    @depend_3 = {}
    @file=File.open(ARGV[0])
    @opt=''    # when input tasks , do some thing
	  @stack_opt=[] #when input a task , it can save 
    @over=[]   #judge 
    @judge = true
    @stack=[]  # save hash struct
    @hash_Key=[] # when input -T options ,I should do some other thing
    @hash_Val=[] #when input -T options, do some other thing
  end
  def create_task_test_hash(arg)
    if /(.*)\s=>\s(.*)/ =~ arg
      @depend_1[$1]=$2
      @task=$1
    else
      @task=arg
    end
  end

  def create_test_echo_hash
    line = @file.gets  
    if /sh(.*)/=~line
      @content=$1
    end
      @depend_3[@task]=@content
  end

  def create_task(line)
    if /task\s(.*)\sdo/ =~ line
    arg = $1
    create_task_test_hash(arg)
    create_test_echo_hash
    @depend_2[@key]=@task
    end
  end
   

  def convert(str)
    temp = str.scan(/(:test)(\d)/)
    rom = []
    temp.each  do  |t|
      rom << t.join
    end
    rom
  end

  def hash_relation
    while line = @file.gets
      if /(.*)\s:default\s=>\s(.*)/=~line
        @depend_1[":default"]=$2
      elsif
        /desc(.*)/=~line
        @key=$1
        line=@file.gets
        create_task(line)
      else
      end
    end
  end

  def execute_without_T_option 
    hash_relation
    if @opt==''
      if @depend_1.has_key?(":default")
        @stack.push(@depend_1[":default"])
      else
        puts "ERROR ARGV"
		  exit
      end
    else
      @stack.push(@stack_opt)
    end
    
    while key = @stack.pop
      if @depend_1.keys.include? key
        mm=@depend_1[key]
        for names in @over
          if names==mm
            @judge=false
            break
          end
        end
        if(@judge)
          @stack.push(key)
          str = @depend_1[key]
          dep_err=convert(str).reverse
          dep_err.each do |ele|
            @stack.push(ele)
          end
        else
          code1=@depend_3[key]
          @over.push(key)
          system code1.delete!("'")
        end
      else
          code =@depend_3[key]
          @over.push(key)
          system code.delete!("'")
      end
    end
  end
  
  def execute_with_T_option
    filename=File.open(ARGV[0])
    filename.each_line do |file|
      if file =~ /task\s:d(.*)/
      elsif file =~ /desc\s'(.*)'/
        @hash_Key.push($1)
      elsif file =~ /task\s:(.*)\s=>\s(.*)do/ || file=~ /task\s:(.*)\sdo/
        @hash_Val.push($1)
      end
    end
    filename.close
    i=0
    length=@hash_Val.length

    while i<length
      print @hash_Val.shift
      print "      # "
      puts @hash_Key.shift
      i=i+1
    end
  end

  def main
    if $has_T
      execute_with_T_option
    else
      execute_without_T_option
    end
  end
end
server=MatchRules.new
server.main

























