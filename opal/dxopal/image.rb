module DXOpal
  class Image
    def self.load(path_or_url)
      raw_img = `new Image()`
      img_promise = %x{
        new Promise(function(resolve, reject) {
          raw_img.onload = function() {
            resolve(raw_img);
          };
          raw_img.src = path_or_url;
        });
      }
      Window._add_remote_resource(img_promise)

      img = new(0, 0)
      %x{
        #{img_promise}.then(function(raw_img){
          img.$_resize(raw_img.width, raw_img.height);
          img.$_draw_raw_image(0, 0, raw_img);
        });
      }
      return img
    end

    def initialize(width, height, color=C_DEFAULT, canvas: nil)
      @width, @height = width, height
      @canvas = canvas || `document.createElement("canvas")`
      @ctx = `#{@canvas}.getContext('2d')`
      _resize(@width, @height)
      box_fill(0, 0, @width, @height, color)
    end
    attr_reader :ctx, :width, :height

    def _resize(w, h)
      @width, @height = w, h
      %x{
        #{@canvas}.width = w;
        #{@canvas}.height = h;
      }
    end

    def draw(x, y, image)
      %x{
        #{@ctx}.putImageData(#{image._image_data}, x, y);
      }
      return self
    end

    def box_fill(x1, y1, x2, y2, color)
      ctx = @ctx
      %x{
        ctx.beginPath();
        ctx.fillStyle = #{_rgb(color)};
        ctx.fillRect(x1, y1, x2-x1, y2-y1); 
      }
      return self
    end

    def circle(x, y, r, color)
      ctx = @ctx
      %x{
        ctx.beginPath();
        ctx.strokeStyle = #{_rgb(color)};
        ctx.arc(x, y, r, 0, Math.PI*2, false)
        ctx.stroke();
      }
      return self
    end

    def circle_fill(x, y, r, color)
      ctx = @ctx
      %x{
        ctx.beginPath();
        ctx.fillStyle = #{_rgb(color)};
        ctx.arc(x, y, r, 0, Math.PI*2, false)
        ctx.fill();
      }
      return self
    end

    def _draw_raw_image(x, y, raw_img)
      %x{
        #{@ctx}.drawImage(#{raw_img}, x, y)
      }
    end

    def _image_data(x=0, y=0, w=@width, h=@height)
      return `#{@ctx}.getImageData(x, y, w, h)`
    end

    def _rgb(color)
      case color.length
      when 4
        rgb = color[1, 3]
      when 3
        rgb = color
      else
        raise "invalid color: #{color.inspect}"
      end
      return "rgb(" + rgb.join(', ') + ")";
    end

    def _rgba(color)
      case color.length
      when 4
        rgba = color[3] + color[1, 3]
      when 3
        rgba = color + [255]
      else
        raise "invalid color: #{color.inspect}"
      end
      return "rgba(" + rgba.join(', ') + ")"
    end
  end
end
