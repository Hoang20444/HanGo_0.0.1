package com.hango.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class EmailService {
  private static final Logger log = LoggerFactory.getLogger(EmailService.class);

  private final JavaMailSender mailSender;

  @Value("${spring.mail.username:}")
  private String mailUsername;

  @Value("${app.mail.from:no-reply@hango.local}")
  private String from;

  public EmailService(ObjectProvider<JavaMailSender> mailSenderProvider) {
    this.mailSender = mailSenderProvider.getIfAvailable();
  }

  public void sendPasswordResetOtp(String to, String otp) {
    if (mailSender == null || !StringUtils.hasText(mailUsername)) {
      log.warn("Email is not configured. OTP for {} is {}", to, otp);
      return;
    }

    SimpleMailMessage message = new SimpleMailMessage();
    message.setFrom(from);
    message.setTo(to);
    message.setSubject("HanGo password reset OTP");
    message.setText(
        "Your HanGo password reset OTP is "
            + otp
            + ". This code expires soon. If you did not request this, please ignore this email.");
    mailSender.send(message);
  }
}
