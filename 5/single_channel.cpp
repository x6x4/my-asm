#include <opencv2/opencv.hpp>
#include <stdexcept>
#include <string>

extern "C" void single_color_channel(unsigned char* image, int width, int height);


cv::Mat read_image(const char* filename) {
    cv::Mat image = cv::imread(filename);
    if (image.empty()) {
        std::cerr << "Error reading image: " << filename << std::endl;
        exit(1);
    }
    return image;
}

void save_image(const char* filename, cv::Mat image) {
    if (!cv::imwrite(filename, image)) {
        std::cerr << "Error writing image: " << filename << std::endl;
        exit(1);
    }
}

void single_color_channel_open_cv(cv::Mat &color_image) {

    std::vector<cv::Mat> channels;
    cv::split(color_image, channels);

    color_image = channels[1]; // Green channel
}

int main(int argc, char** argv) {

    try {

        std::string filename = std::string(argv[1]);
        std::string new_filename = std::string("grey_")+argv[1];

        // Read the color image
        cv::Mat color_image = read_image(filename.c_str());
        
        #ifdef C_IMG
        std::cout << "C version is in use\n";
        single_color_channel_open_cv(color_image);
        #else
        std::cout << "NASM version is in use\n";
        single_color_channel(color_image.data, color_image.cols, color_image.rows);
        #endif

        save_image(new_filename.c_str(), color_image);
    }
    catch (std::logic_error &err) {
        std::cout << err.what() << std::endl;
    }
    catch (std::runtime_error &err) {
        std::cout << err.what() << std::endl;
    }

    return 0;
}
