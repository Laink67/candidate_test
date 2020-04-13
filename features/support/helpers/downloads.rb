
PATH = Dir.pwd + "/features/tmp"

# get array with all downloads in PATH
def downloads
  Dir.glob("*", base: PATH)
end

# get last download file
def get_download
  downloads.first
end

# checking for files in dir
def downloaded?
  downloads.any? && !downloading?
end

# check that the file is in the process of loading
def downloading?
  downloads.grep(/\.crdownload$/).any?
end

# clear download's folder
def clear_downloads
  FileUtils.rm_f(Dir.glob(PATH + "/*"))
end

# check name of last download file
def check_name(name)
  get_download == name
end

Before do
  clear_downloads
end

