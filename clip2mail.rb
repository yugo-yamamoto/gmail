#! /usr/bin/env ruby
require 'mail'

# 以下にgmailのアプリパスワードを設定 https://accounts.google.com/IssuedAuthSubTokens?hide_authsub=1
mail_passwd = ENV['GMAIL_PASS']
mail_from   = ENV['GMAIL_ADDR'] # fromのアカウントとアプリパスワードを作ったアカウントは揃える必要がある
mail_to     = ENV['GMAIL_ADDR']

# クリップボードからテキストを取得（Macならpbpaste）
clip = `powershell.exe -command "[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8');Get-Clipboard"`

lines = clip.split(/\n|\r\n/)
mail_subject = lines.shift # クリップボードの一行目がタイトル
mail_body    = lines.join("\n")  # 二行目以降が本文

if mail_body.nil?
  puts '本文が空です。クリップボードにテキストがありません'
  exit
end

Mail.defaults do
  delivery_method :smtp, {
    address: 'smtp.gmail.com',
    port: 587,
    domain: 'example.com',
    user_name: mail_from,
    password: mail_passwd,
    authentication: :login,
    enable_starttls_auto: true
  }
end

m = Mail.new do
  from     mail_from
  to       mail_to
  subject  mail_subject
  body     mail_body
end
m.charset = 'UTF-8'
m.content_transfer_encoding = '8bit'
m.deliver
