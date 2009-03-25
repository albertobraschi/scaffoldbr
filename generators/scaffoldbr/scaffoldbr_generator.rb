class ScaffoldbrGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_migration => false, :force_plural => false, :with_xml => false

  attr_reader   :controller_name,
  :controller_class_path,
  :controller_file_path,
  :controller_class_nesting,
  :controller_class_nesting_depth,
  :controller_class_name,
  :controller_underscore_name,
  :controller_singular_name,
  :controller_plural_name
  alias_method  :controller_file_name,  :controller_underscore_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    if @name == @name.pluralize && !options[:force_plural]
      logger.warning "Nome do model no Plural detectado, usando nome em singular.  Use o plural passando --force-plural."
      @name = @name.singularize
    end

    @controller_name = @name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_underscore_name, @controller_plural_name = inflect_names(base_name)
    @controller_singular_name=base_name.singularize
    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions("#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_name)

      # Controller, helper, views, test and stylesheets directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_file_name))
      m.directory(File.join('app/views/layouts', controller_class_path))
      m.directory(File.join('test/functional', controller_class_path))
      m.directory(File.join('test/unit', class_path))
      m.directory(File.join('test/unit/helpers', class_path))
      m.directory(File.join('public/stylesheets', class_path))

      create_scaffold_views(m)
      create_scaffold_layouts(m)
      create_scaffold_estilos(m)
      create_scaffold_imagens(m)    

      m.template(
      'controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      )

      m.template('functional_test.rb', File.join('test/functional', controller_class_path, "#{controller_file_name}_controller_test.rb"))
      m.template('helper.rb',          File.join('app/helpers',     controller_class_path, "#{controller_file_name}_helper.rb"))
      m.template('helper_test.rb',     File.join('test/unit/helpers',    controller_class_path, "#{controller_file_name}_helper_test.rb"))

      m.route_resources controller_file_name

      m.dependency 'model', [name] + @args, :collision => :skip
    end
  end

  protected
  # Override with your own usage banner.
  def banner
    "Usando: #{$0} scaffoldbr NomeDoModel [campo:tipo, campo:tipo]"
  end

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Opções:'
    opt.on("--skip-timestamps",
    "Não adiciona timestamps ao arquivo de migration gerado para este model") { |v| options[:skip_timestamps] = v }
    opt.on("--skip-migration",
    "Não gera o arquivo de migration para este model") { |v| options[:skip_migration] = v }
    opt.on("--force-plural",
    "Força a pluralização do nome do model") { |v| options[:force_plural] = v }
    opt.on("--with-xml",
    "Gera respond_to com formato xml no controller") { |v| options[:with_xml] = v }
  end

  def create_scaffold_views(m)
    %w( index show new edit _form).each do |action|
      m.template("view_#{action}.html.erb", File.join('app/views', controller_class_path, controller_file_name, "#{action}.html.erb")
      )
    end
  end

  def create_scaffold_layouts(m)
    %w( application _erro _cabecalho _menu _rodape ).each do |layout|
      m.template("#{layout}.html.erb", File.join('app/views/layouts', "#{layout}.html.erb"))
    end
  end

  def create_scaffold_imagens(m)
    %w( add alert back cancel delete edit escolha help info key money music no ok ok2 pass photo print restrito save user video view ).each do |imagem|
      m.file("images/button_#{imagem}.gif", "public/images/button_#{imagem}.gif")
    end
  end

  def create_scaffold_estilos(m)
    %w( botoes erro padrao paginacao tabela menu ).each do |estilo|
      m.file("stylesheets/#{estilo}.css", "public/stylesheets/#{estilo}.css")
    end
  end

  def model_name
    class_name.demodulize
  end
end
