
class ImageUtils {

  static String thumbnailFromUrl(String url,
      {int? width, int? height, int? quality}) {
    if (url.isEmpty) return '';
    String pwidth = ((width ?? 0) > 0) ? width.toString() : '64';
    String pheight = ((height ?? 0) > 0) ? height.toString() : '64';
    String pquality = ((quality ?? 0) > 0) ? quality.toString() : '100';
    String parameters =
        '?x-image-process=image/resize,w_${pwidth},h_${pheight}/quality,Q_${pquality}';
    String res = url + parameters;
    return res;
  }
}
