# encoding: UTF-8

Gem::Specification.new do |s|
  s.name     = 'static-model'
  s.version  = '1.1.1'
  s.summary  = 'A base non–database-backed model for Rails.'
  s.homepage = 'http://codyrobbins.com/software/static-model'
  s.author   = 'Cody Robbins'
  s.email    = 'cody@codyrobbins.com'

  s.post_install_message = '
-------------------------------------------------------------
Follow me on Twitter! http://twitter.com/codyrobbins
-------------------------------------------------------------

'

  s.files = `git ls-files`.split

  s.add_dependency('activemodel')
end