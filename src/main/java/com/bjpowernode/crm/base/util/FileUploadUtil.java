package com.bjpowernode.crm.base.util;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;

//上传文件工具类
public class FileUploadUtil {

    public static ResultVo fileUpload(MultipartFile[] img, HttpServletRequest request){
        ResultVo resultVo = new ResultVo();
            //文件夹:包含其他文件的文件 文件
            String realPath = request.getSession().getServletContext().getRealPath("/upload");
            //File类查找文件位置，IO流是操作文件内容
            File file = new File(realPath);
            if(!file.exists()){
                //mkDir:创建一层目录
                file.mkdirs();
            }
            for (MultipartFile multipartFile : img) {
                //获取上传文件的名字 美女.jpg 1281218928美女.jpg
                String filename = multipartFile.getOriginalFilename();
                //防止不同用户上传相同文件名的文件
                filename = System.currentTimeMillis() + filename;
                //底层封装上传过程，通过IO流把文件写入到磁盘
                ///crm/upload/1281218928美女.jpg
                try {
                    //文件名后缀名是否合法
                    verifySuffix(filename);
                    //校验大小是否超过范围
                    verifyMaxSize(multipartFile);
                    String savePath = realPath + File.separator + filename;
                    multipartFile.transferTo(new File(realPath + File.separator + filename));
                    resultVo.setOk(true);
                    resultVo.setMessage("上传头像成功");
                    //request.getContextPath():/项目名 /crm/upload/2323.png
                    String path = request.getContextPath() + File.separator + "upload" + File.separator + filename;
                    resultVo.setT(path);
                } catch (IOException e) {
                    e.printStackTrace();
                }catch (CrmException e1){
                    resultVo.setMessage(e1.getMessage());
                }
            }
        return resultVo;
    }

    //校验大小
    private static void verifyMaxSize(MultipartFile img) {
        //用户上传文件的大小
        long size = img.getSize();
        //允许最大上传的大小 <=2M
        long maxSize = 0;
        //1M=1024kb=1024byte=8bit
        if(size > 2 * 1024 * 1024){
            throw new CrmException(CrmEnum.UPLOAD_MAX_SIZE);
        }
    }

    //校验后缀名 张三.4343.png/bmp
    private static void verifySuffix(String filename) {
        //filename.lastIndexOf("."):取出最后一个.在原字符串中的索引位置
        String suffix = filename.substring(filename.lastIndexOf(".") + 1);
        String suffixs = "png,gif,bmp,jpeg";
        if(!suffixs.contains(suffix)){
            throw new CrmException(CrmEnum.UPLOAD_SUFFIX);
        }
    }
}
