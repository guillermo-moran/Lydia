# Lydia
## Personal Assistant for OSX 10.10+



#### What is it?

**Lydia** is an experimental personal assistant for OSX. Work in progress. Not many features. Mostly server-side.

#### How does it work?

Press the spacebar **or** click the speech wave to begin talking.

Press the spacebar **or** click the speech wave to submit your speech to Google's Speech Servers _(See: Obtaining a Google API Key.)_.

Lydia automatically submits your speech to Lydia's server and generates a response. You may use Lydia's server, or create your own. _(See: Creating Your Own Response Server)_.

#### Lydia's Server

Lydia's server is a simple response server that generates responses based on your queries. It recognized regular speech expressions, or queries Wolfram Alpha if it it does not recognize the submitted command.

#### Obtaining a Google API Key (v2)

In order to use Google's Speech API, you must obtain an API Key from The Chromium Project.

See this: Generating [your own Speech API Key](http://www.chromium.org/developers/how-tos/api-keys), you can only make 50 requests per day.

#### Creating Your Own Response Server

You can create your own server by sending requests to a simple PHP script. An Example PHP Script is shown below:
<code>
	
	 /*
     Variables Lydia Recognizes:
     These are shortcuts that Lydia parses (or will soon be able to parse).

     $nickname
     <Get_Date>
     <Get_Time>
     <Restart_SB>
     <Reboot>
     <Shut_Down>
     <Show_Image>

     OPEN_APP_WITH_URL: = <App URL Identifier>

     RUN_COMMAND: <System Command>


     Weather Syntax:
     <Get_Weather>: - Initializes Esra Assistant's Weather Method
     <CITY> - Calls Esra's configured city
     <DEGREES> - Current weather in degrees
     <CONDITIONS> - Current weather conditions

     * Example Usage: <Get_Weather>: It is currently <DEGREES> degrees, <CONDITIONS> in <CITY> *

     */
     
     // POST Your Nickname
    $nickname = $_POST['name'];

    /* String Formatting */

    $recieved = $_POST['query'];
    $recieved = strtolower($recieved);
    
    $recieved = str_replace("assistant: ","",$recieved);
    $recieved = str_replace(" / ","divided by",$recieved);
    $recieved = str_replace("/"," divided by ",$recieved);
    $recieved = str_replace("+"," plus ",$recieved);
    $recieved = str_replace("!","",$recieved);
    $recieved = str_replace("?","",$recieved);
    $recieved = str_replace("'","",$recieved);
    $recieved = str_replace(".","",$recieved);
    $recieved = str_replace(",","",$recieved);
    $recieved = ' ' . $recieved . ' ';

            

    if (preg_match("/hello/", $recieved)) {

        echo "hello world!";
    }

</code>

## Licensing

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.
