test_name "puppet module install (agent)"

module_author = "pmtacceptance"
module_name   = "nginx"
module_dependencies = []

orig_installed_modules = get_installed_modules_for_hosts hosts
teardown do
  rm_installed_modules_from_hosts orig_installed_modules, (get_installed_modules_for_hosts hosts)
end

agents.each do |agent|
  step 'setup'
  stub_forge_on(agent)

<<<<<<< HEAD
  modulesdir = agent.tmpdir('puppet_module_build')
  teardown do
    on agent, "rm -rf #{modulesdir}"
  end

  step "install module to '#{modulesdir}'"
  on(agent, puppet("module install pmtacceptance-nginx  --target-dir='#{modulesdir}'")) do
    assert_match(/#{modulesdir}\n└── pmtacceptance-nginx \(.*\)/, stdout)
=======
  distmoduledir = on(agent, puppet("agent", "--configprint", "confdir")).stdout.chomp + "/modules"

  step "install module '#{module_author}-#{module_name}'"
  on(agent, puppet("module install #{module_author}-#{module_name}")) do
    assert_module_installed_ui(stdout, module_author, module_name)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
  end
  assert_module_installed_on_disk(agent, distmoduledir, module_name)
end
