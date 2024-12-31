import count_vimplugins_stars/io.{read_input_file, read_output_file}

pub fn do_work(input_file: String, output_file: String) {
  let plugin_urls = read_input_file(input_file)
  let already_computed = read_output_file(output_file)
}
