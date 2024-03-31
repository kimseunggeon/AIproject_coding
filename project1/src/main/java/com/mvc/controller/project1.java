package com.mvc.controller;

import java.io.FileInputStream;
import java.io.IOException;

import java.nio.charset.Charset;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.core.io.InputStreamResource;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
@RestController
public class project1{
	@PostMapping("/postman")
	   @ResponseBody()
	   public String postMan(@RequestBody Object json) throws JsonParseException, JsonMappingException, IOException {   
	      RestTemplate restTemplate = new RestTemplate();
	      
	      // ��Ŀ ���� url
	      String url = "http://localhost:8000/compile";
	      
	      //header  :   headers.set("����̸�", "��");
	      HttpHeaders headers = new HttpHeaders();
	      headers.setContentType(new MediaType("application","json",Charset.forName("UTF-8")));//contentType
	      headers.setAccept(Arrays.asList(new MediaType[] { MediaType.APPLICATION_JSON }));//accept
	      
	      //body
	      LinkedHashMap<String,String> body = (LinkedHashMap)json;

	      // HttpEntity = header + body
	      HttpEntity<Map<String, String>> entity = new HttpEntity<Map<String, String>>(body, headers);
	      // HTTP ��û : ��� String
	      ResponseEntity<String> responseEntity = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
	      String response = responseEntity.getBody();
	      
	      System.out.println("response : "+response);
	      // ���� �� ���������� ����
	      return response;
	   }
	
	@PostMapping("/download_model")
	public ResponseEntity<InputStreamResource> fileDownload() throws IOException{
	    Path filePath = Paths.get("<file_path_string>");
	    InputStreamResource resource = new InputStreamResource(new FileInputStream(filePath.toString()));
	    String fileName = "model.h5";
		System.out.println("Success download input excel file : " + filePath);
	    return ResponseEntity.ok()
	            .contentType(MediaType.APPLICATION_OCTET_STREAM)
	            .cacheControl(CacheControl.noCache())
	            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + fileName)
	            .body(resource);
	}
}