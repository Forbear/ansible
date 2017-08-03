from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

from ansible import errors
dest_dict = {
  "Ubuntu": "ubuntu",
  "CentOS": "rhel",
  "RedHat": "rhel",
  "Fedora": "rhel",
  "MacOSX": "darwin",
  "SuSE": "suse"
}

def get_mongo_src(arg, *args ):
  rezult = None
  if len(args) < 3:
    return rezult
  #print args[2]
  ver = args[1].replace('.', '')
  if ver < 10:
    ver += 0
  for i in arg:
    try:
      if dest_dict[args[0]] in i and ver in i and args[2] in i:
        rezult = i
    except KeyError:
      return rezult
  return rezult

class FilterModule(object):
  def filters(self):
    return { 'get_mongo_src': get_mongo_src }
