class Pathname
  rdl_nowrap

  type 'self.getwd', '() -> Pathname'
  type 'self.glob', '(String p1, ?String p2) -> Array<Pathname>'
  type 'self.new', '(%string or Pathname p1) -> Pathname' # p1 can be String-like
  rdl_alias 'self.pwd', 'self.getwd'
  type :+, '(String or Pathname other) -> Pathname'
  rdl_alias :/, :+
  type :<=>, '(%any p1) -> -1 or 0 or 1 or nil'
  type :==, '(%any p1) -> %bool'
  type :===, '(%any p1) -> %bool'
  type :absolute?, '() -> %bool'
  type :ascend, '() { (Pathname) -> %any } -> %any'
  type :atime, '() -> Time'
  type :basename, '(?String p1) -> Pathname' # guessing about arg type
  type :binread, '(?Fixnum length, ?Fixnum offset) -> String'
  type :binwrite, '(String, ?Fixnum offset) -> Fixnum' # TODO open_args
  type :birthtime, '() -> Time'
  type :blockdev?, '() -> %bool'
  type :chardev?, '() -> %bool'
  type :children, '(%bool with_directory) -> Array<Pathname>'
  type :chmod, '(Fixnum mode) -> Fixnum'
  type :chown, '(Fixnum owner, Fixnum group) -> Fixnum'
  type :cleanpath, '(?%bool consider_symlink) -> %any'
  type :ctime, '() -> Time'
  type :delete, '() -> %any'
  type :descend, '() { (Pathname) -> %any } -> %any'
  type :directory?, '() -> %bool'
  type :dirname, '() -> Pathname'
  type :each_child, '(%bool with_directory) { (Pathname) -> %any } -> %any'
  type :each_entry, '() { (Pathname) -> %any } -> %any'
  type :each_filename, '() { (String) -> %any } -> %any'
  type :each_filename, '() -> Enumerator<String>'
  type :each_line, '(?String sep, ?Fixnum limit) { (String) -> %any } -> %any' # TODO open_args
  type :each_line, '(?String sep, ?Fixnum limit) -> Enumerator<String>'
  type :entries, '() -> Array<Pathname>'
  type :eql?, '(%any) -> %bool'
  type :executable?, '() -> %bool'
  type :executable_real?, '() -> %bool'
  type :exist?, '() -> %bool'
  type :expand_path, '(?(String or Pathname) p1) -> Pathname'
  type :extname, '() -> String'
  type :file?, '() -> %bool'
  type :find, '(%bool ignore_error) { (Pathname) -> %any } -> %any'
  type :find, '(%bool ignore_error) -> Enumerator<Pathname>'
  type :fnmatch, '(String pattern, ?Fixnum flags) -> %bool'
  type :freeze, '() -> self' # TODO return type?
  type :ftype, '() -> String'
  type :grpowned?, '() -> %bool'
  type :join, '(*(String or Pathname) args) -> Pathname'
  type :lchmod, '(Fixnum mode) -> Fixnum'
  type :lchown, '(Fixnum owner, Fixnum group) -> Fixnum'
  type :lstat, '() -> File::Stat'
  type :make_link, '(String old) -> 0'
  type :symlink, '(String old) -> 0'
  type :mkdir, '(String p1) -> 0'
  type :mkpath, '() -> %any' # TODO return?
  type :mountpoint?, '() -> %bool'
  type :mtime, '() -> Time'
  type :open, '(?String mode, ?String perm, ?Fixnum opt) -> File'
  type :open, '(?String mode, ?String perm, ?Fixnum opt) { (File) -> t } -> t'
  type :opendir, '(?Encoding) -> Dir'
  type :opendir, '(?Encoding) { (Dir) -> u } -> u'
  type :owned?, '() -> %bool'
  type :parent, '() -> Pathname'
  type :pipe?, '() -> %bool'
  type :read, '(?Fixnum length, ?Fixnum offset, ?Fixnum open_args) -> String'
  type :readable?, '() -> %bool'
  type :readable_real, '() -> %bool'
  type :readlines, '(?String sep, ?Fixnum limit, ?Fixnum open_args) -> Array<String>'
  type :readlink, '() -> String file'
  type :realdirpath, '(?String p1) -> String'
  type :realpath, '(?String p1) -> String'
  type :relative?, '() -> %bool'
  type :relative_path_from, '(String or Pathname base_directory) -> Pathname'
  type :rename, '(String p1) -> 0'
  type :rmdir, '() -> 0'
  type :rmtree, '() -> 0'
  type :root?, '() -> %bool'
  type :setgid?, '() -> %bool'
  type :setuid?, '() -> %bool'
  type :size, '() -> Fixnum'
  type :size?, '() -> %bool'
  type :socket?, '() -> %bool'
  type :split, '() -> [Pathname, Pathname]'
  type :stat, '() -> File::Stat'
  type :sticky?, '() -> %bool'
  type :sub, '(*String args) -> Pathname'
  type :sub_ext, '(String p1) -> Pathname'
  type :symlink?, '() -> %bool'
  type :sysopen, '(?Fixnum mode, ?Fixnum perm) -> Fixnum'
  type :taint, '() -> self'
  type :to_path, '() -> String'
  rdl_alias :to_s, :to_path
  type :truncate, '(Fixnum length) -> 0'
  type :unlink, '() -> Fixnum'
  type :untaint, '() -> self'
  type :utime, '(Time atime, Time mtime) -> Fixnum'
  type :world_readable?, '() -> %bool'
  type :world_writable?, '() -> %bool'
  type :writable?, '() -> %bool'
  type :writable_real?, '() -> %bool'
  type :write, '(String, ?Fixnum offset, ?Fixnum open_args) -> Fixnum'
  type :zero?, '() -> %bool'
end
