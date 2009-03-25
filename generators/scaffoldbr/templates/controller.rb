class <%= controller_class_name %>Controller < ApplicationController
  
  before_filter :find_<%= file_name %>, :except => [:new, :create, :edit, :update]
  # GET /<%= table_name %>
  <% if options[:with_xml] %>
  # GET /<%= table_name %>.xml
  <% end %>
  def index
    @<%= file_name.pluralize %> = <%= class_name %>.paginate :page => params[:page], :per_page => 50
 <% if options[:with_xml] %>
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= table_name %> } 
    end
     <% end %>
  end

  # GET /<%= table_name %>/1
  <% if options[:with_xml] %>
  # GET /<%= table_name %>/1.xml
  <% end %>
  def show
<% if options[:with_xml] %>
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= file_name %> }
    end
    <% end %>
  end

  # GET /<%= table_name %>/new
  <% if options[:with_xml] %>
  # GET /<%= table_name %>/new.xml
  <% end %>
  def new
    @<%= file_name %> = <%= class_name %>.new
<% if options[:with_xml] %>
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @<%= file_name %> }
    end
    <% end %>
  end

  # GET /<%= table_name %>/1/edit
  def edit
  end

  # POST /<%= table_name %>
  <% if options[:with_xml] %>
  # POST /<%= table_name %>.xml
  <% end %>
  def create
    @<%= file_name %> = <%= class_name %>.new(params[:<%= file_name %>])
<% if options[:with_xml] %>
    respond_to do |format|
      if @<%= file_name %>.save
        flash[:notice] = '<%= class_name.humanize %> criada com sucesso.'
        format.html { redirect_to(<%= table_name %>_url) }
        format.xml  { render :xml => @<%= file_name %>, :status => :created, :location => @<%= file_name %> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
    <% else %>
     if @<%= file_name %>.save
        flash[:notice] = '<%= class_name.humanize %> criada com sucesso.'
        redirect_to(<%= table_name %>_url)
      else
        render :action => "new"
      end
    <% end %>
    
  end

  # PUT /<%= table_name %>/1
  <% if options[:with_xml] %>
  # PUT /<%= table_name %>/1.xml
  <% end %>
  def update
<% if options[:with_xml] %>
    respond_to do |format|
      if @<%= file_name %>.update_attributes(params[:<%= file_name %>])
        flash[:notice] = '<%= class_name.humanize %> atualizada com sucesso.'
        format.html { redirect_to(<%= table_name %>_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
    <% else %>
     if @<%= file_name %>.update_attributes(params[:<%= file_name %>])
        flash[:notice] = '<%= class_name.humanize %> atualizada com sucesso.'
        redirect_to(<%= table_name %>_url)
      else
        render :action => "edit"
      end
    <% end %>
  end

  # DELETE /<%= table_name %>/1
  <% if options[:with_xml] %>
  # DELETE /<%= table_name %>/1.xml
  <% end %>
  def destroy
    <% if options[:with_xml] %>
    if @<%= file_name %>.destroy
    respond_to do |format|
      flash[:notice] = '<%= class_name.humanize %> apagada com sucesso.'
      format.html { redirect_to(<%= table_name %>_url) }
      format.xml  { head :ok }
    end
  else
    respond_to do |format|
      flash[:notice] = '<%= class_name.humanize %> NÃO pode ser apagada. Tente novamente!'
      format.html { redirect_to(<%= table_name %>_url) }
      format.xml  { head :ok }
    end
  end
    <% else %>
    if @<%= file_name %>.destroy
      flash[:notice] = '<%= class_name.humanize %> apagada com sucesso.'
      redirect_to(<%= table_name %>_url)
  else
      flash[:alert] = '<%= class_name.humanize %> NÃO pode ser apagada. Tente novamente!'
      redirect_to(<%= table_name %>_url)
  end  
  <% end %>
  end
  
  private
  
  def find_<%= file_name %>
    @<%= file_name %> = <%= class_name %>.find(params[:id])
  end
  
end
