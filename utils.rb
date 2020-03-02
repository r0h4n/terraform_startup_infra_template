VALID_ENVIRONMENTS = %w(beta staging core test production)
VALID_COMMANDS = %w(plan apply encrypt)

TERRAFORM_S3_BUCKET = 'com.startup.terraform-state'.freeze
TERRAFORM_S3_REGION = 'us-west-1'.freeze

NOCOLOR = "\033[0m".freeze
RED = "\033[0;31m".freeze

def check_valid_environment!
  return if VALID_ENVIRONMENTS.include?(@environment)
  if @environment.nil?
    puts 'You must pass an environment as the first argument to cmd startup_ops'
  else
    puts "'#{@environment}' is not a valid environment to run Terraform against."
  end
  puts "Valid environments are: 'staging', 'beta', 'core', 'test' and 'production'."
  exit(1)
end

def check_valid_command!
  return if VALID_COMMANDS.include?(@command)
  if @command.nil?
    puts 'You must pass a valid command as the second argument to cmd startup_ops'
  else
    puts "'#{@command}' is not a valid command for startup_ops."
  end
  puts 'Valid commands are:'
  puts "-  'plan' - runs Terraform plan against the environment"
  puts "-  'apply' - runs Terraform apply against the environment"
  exit(1)
end

def confirm_production!
  return if @environment != 'production'
  puts RED + '+--------------------------------------------------------------------+' + NOCOLOR
  puts RED + '|' + NOCOLOR + '  You are about to run this code against PRODUCTION. Are you sure?  '+ RED + '|'
  puts RED + '|' + NOCOLOR + '  Type \'yes\' to continue.                                           '+ RED + '|'
  puts RED + '+--------------------------------------------------------------------+' + NOCOLOR
  print "\n>> "

  STDOUT.flush
  response = STDIN.gets.chomp

  return true if response == 'yes'
  puts 'Aborted.'
  exit(1)
end

def determine_envchain_namespace
  if @environment == 'test'
    @namespace = "startup_test"
  else
    @namespace = "startup"
  end
end

def with_terraform_remote_state
  set_terraform_remote_state(@environment)
  yield
end

def set_terraform_remote_state(environment)
  puts %x(cd ./terraform/ && envchain #{@namespace} terraform init \
    -backend-config="key=#{environment}/terraform.tfstate" \
    -backend-config="access_key=$AWS_ACCESS_KEY" \
    -backend-config="secret_key=$AWS_SECRET_KEY" \
    -reconfigure \
    && cd ..
  )
  raise "Unable to update Terraform state configuration #{res}" unless $? == 0
end

def terraform_plan!
  cmd = "cd ./terraform/ && envchain #{@namespace} terraform plan -var-file=./#{@environment}/terraform.tfvars -module-depth=-1 #{@other_args.join(' ')} && cd .."
  puts "Running '#{cmd}'"
  exec(cmd)
end

def terraform_apply!
  cmd = "cd ./terraform/ && envchain #{@namespace} terraform apply -var-file=./#{@environment}/terraform.tfvars #{@other_args.join(' ')} && cd .."
  puts "Running '#{cmd}'"
  exec(cmd)
end
