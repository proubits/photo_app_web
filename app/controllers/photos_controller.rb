class PhotosController < ApplicationController
  include DropboxGateway
  caches_page :show
  # GET /photos
  # GET /photos.json
  def index
    if user_signed_in?
      @photos = Photo.mine(current_user.id).paginate(:per_page => @@per_page, :page => find_page_no)
      @taker_id = @photos.first.taker_id unless @photos.empty?
    else
      @taker_id ||= params[:taker]
      @taker_id ||= params[:taker_id]
      @photos = Photo.where(:taker_id => @taker_id).order("id desc").paginate(:per_page => @@per_page, :page => find_page_no)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    if user_signed_in?
      @photo = Photo.where(:user_id => current_user.id).find(params[:id])
      render :text => "You don't have photos." and return unless @photo
      @taker_id = @photo.taker_id
    else
      render :text => "You don't have photos." and return unless params[:taker_id].present?
      @taker_id = params[:taker_id]
      @photo = Photo.find(params[:id]) rescue nil
    end
    render :text => "Can't find the photo." and return if @photo.nil?
    render :text => "Can't find the photo." and return if @photo.taker_id != @taker_id
    respond_to do |format|
      format.html do
        path = @photo.path(params[:thumb].present?)
        send_data(
          download(path),
          :type => "image/jpeg",
          :filename => params[:thumb].present? ? "#{@photo.name}_tn.jpg" : "#{@photo.name}.jpg",
          :disposition => 'inline'
        )
      end
      format.json { render json: @photo }
    end
  end

  # POST /photos
  # POST /photos.json
  # params -- image, thumb, taker, gps, size#, tk, ts
  def create
    #@photo = Photo.new(params[:photo])
    @photo = Photo.new(:taker=>params[:taker], :location=>params[:gps])
    if params[:taker].present?
      dt = Time.now.strftime("%Y%m%d%H%M%S")
      @photo.name = dt
      t = @photo.taker.split('-')
      @photo.taker_id = t.first
      @photo.taker_no = t.last if t.size > 1
    end

    respond_to do |format|
      if @photo.save
#        #heroku not allow to write file
#        dir = File.join ::Rails.root.to_s, 'public', 'photos', @photo.taker_id
#        Dir.mkdir dir unless File.directory? dir
#        filename = File.join dir, "#{@photo.name}.jpg"
#
#        File.open(filename, 'wb') do|f|
#          f.write(Base64.decode64(params[:image]))
#        end
        filename = File.join @photo.taker_id, "#{@photo.name}.jpg"
        resp = upload2db(Base64.decode64(params[:image]), filename)#, {:t_key=>params[:tk], :t_secret=>params[:ts]}
        logger.debug resp
        #upload thumbnail too
        filename = File.join @photo.taker_id, "#{@photo.name}_tn.jpg"
        resp = upload2db(Base64.decode64(params[:thumb]), filename)#, {:t_key=>params[:tk], :t_secret=>params[:ts]}
        logger.debug resp
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render json: @photo, status: :created, location: @photo }
        format.xml {render action: "show"}
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /photos/
  def associate
    taker_id ||= params[:taker]
    taker_id ||= params[:taker_id]
    user = User.find_by_email(params[:email]) rescue nil
    if user.nil?
      flash_message = {alert: "Can't associate your account!"}
      path = photos_path(:taker_id => taker_id)
    else
      Photo.associate(user.id, taker_id)
      sign_in(:user, user)
      path = photos_path
      flash_message = {notice: "Your photos are now associated with your account!"}
    end

    respond_to do |format|
      format.html { redirect_to path, flash_message }
      format.json { render json: @photos }
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end
end
