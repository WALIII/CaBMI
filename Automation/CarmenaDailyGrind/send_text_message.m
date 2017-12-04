function send_text_message(number,carrier,subject,message)
% SEND_TEXT_MESSAGE send text message to cell phone or other mobile device.
%    SEND_TEXT_MESSAGE(NUMBER,CARRIER,SUBJECT,MESSAGE) sends a text message
%    to mobile devices in USA. NUMBER is your 10-digit cell phone number.
%    CARRIER is your cell phone service provider, which can be one of the
%    following: 'Alltel', 'AT&T', 'Boost', 'Cingular', 'Cingular2',
%    'Nextel', 'Sprint', 'T-Mobile', 'Verizon', or 'Virgin'. SUBJECT is the
%    subject of the message, and MESSAGE is the content of the message to
%    send.
%
%    Example:
%      send_text_message('617-529-0762','Verizon', ...
        % 'Calculation Complete','CIRCE is waiting for input')
%      send_text_message('617-529-0762','Verizon', ...
%         'This is a text message without subject')
%
%   See also SENDMAIL.
%
% You must modify the first two lines of the code (code inside the double
% lines) before using.

% Ke Feng, Sept. 2007
% Please send comments to: jnfengke@gmail.com
% $Revision: 1.0.0.0 $  $Date: 2007/09/28 16:23:26 $

% =========================================================================
% YOU NEED TO TYPE IN YOUR OWN EMAIL AND PASSWORDS:
mail = 'wal3lab@gmail.com';    %Your GMail email address
password = 'madlib3RD1989';          %Your GMail password
% =========================================================================

if nargin == 3
    message = subject;
    subject = '';
end

% Format the phone number to 10 digit without dashes
number = strrep(number, '-', '');
if length(number) == 11 && number(1) == '1';
    number = number(2:11);
end

% Information found from
% http://www.sms411.net/2006/07/how-to-send-email-to-phone.html
switch strrep(strrep(lower(carrier),'-',''),'&','')
    case 'alltel';    emailto = strcat(number,'@message.alltel.com');
    case 'att';       emailto = strcat(number,'@mmode.com');
    case 'boost';     emailto = strcat(number,'@myboostmobile.com');
    case 'cingular';  emailto = strcat(number,'@cingularme.com');
    case 'cingular2'; emailto = strcat(number,'@mobile.mycingular.com');
    case 'nextel';    emailto = strcat(number,'@messaging.nextel.com');
    case 'sprint';    emailto = strcat(number,'@messaging.sprintpcs.com');
    case 'tmobile';   emailto = strcat(number,'@tmomail.net');
    case 'verizon';   emailto = strcat(number,'@vtext.com');
    case 'virgin';    emailto = strcat(number,'@vmobl.com');
end

%% Set up Gmail SMTP service.
% Note: following code found from
% http://www.mathworks.com/support/solutions/data/1-3PRRDV.html
% If you have your own SMTP server, replace it with yours.

% Then this code will set up the preferences properly:
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);

% The following four lines are necessary only if you are using GMail as
% your SMTP server. Delete these lines wif you are using your own SMTP
% server.


props=java.lang.System.getProperties;
pp=props.setProperty('mail.smtp.auth','true'); %#ok
pp=props.setProperty('mail.smtp.socketFactory.class','javax.net.ssl.SSLSocketFactory'); %#ok
pp=props.setProperty('mail.smtp.socketFactory.port','465'); %#ok

%% Send the email
sendmail(emailto,subject,message)

if strcmp(mail,'matlabsendtextmessage@gmail.com')
    disp('Please provide your own gmail for security reasons.')
    disp('You can do that by modifying the first two lines of the code')
    disp('after the bulky comments.')
end
