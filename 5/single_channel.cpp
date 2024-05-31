#include <opencv2/opencv.hpp>

int main() {
    // Read the color image
    cv::Mat color_image = cv::imread("yurochka.png");

    // Split the color channels
    std::vector<cv::Mat> channels;
    cv::split(color_image, channels);

    // Take the green channel as the grayscale image
    cv::Mat gray_image = channels[1]; // Green channel
    
    cv::imwrite("yurochka grey.png", gray_image);

    return 0;
}
