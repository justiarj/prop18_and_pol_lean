#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library('ggplot2')
library('shiny')
library('dplyr')
library('plotly')
library('shinythemes')

data <- read.csv("Data/prop18_lean_omni.csv", 
                 header = TRUE, fill = TRUE)

data <- data%>%
    filter(ifelse(lean > 0, party == "republican", party == "democrat")) # Removing losing Candidates for simplicity

data$Color <- ifelse(data$lean > 0, "firebrick", "Sky Blue")

# Filtering data into separate data sets for comparing both presidential and senate races
president <- data%>%
    filter(office == "US President")

senate <- data%>%
    filter(office == "US Senate")

# Define UI for application that graphs the political lean  
ui <- fluidPage(
    
    # Shiny Theme
    theme = shinytheme("simplex"),

    # Application title
    titlePanel("Political Lean by State"),

    # Sidebar with a selection input for state 
    sidebarLayout(
        sidebarPanel(
            HTML("<h3> Prop 18:  </h3> <br/> A <b> yes </b> vote supports this constitutional amendment to allow 17-year-olds who will be 18 at the time of the next general election to vote in primary elections and special elections. <br/> <br/>

A <b> no </b> vote opposes this constitutional amendment, thereby continuing to prohibit 17-year-olds who will be 18 at the time of the next general election to vote in primary elections and special elections. <br/> <br/>

A number of states have passed a similar law to this one. We examine political lean for each of these states in presidential and senatorial elections before and after passage of their similar amendments. We hypothesize that a yes vote does not affect enough new voters to create an appreciable change in political partisan makeup. <br/> <br/>

To test this hypothesis, the political lean of each of the observed states was calculated by the difference between the voting percentage for Republican versus Democrat candidates in the presidential and senatorial elections. A positive difference indicates a Republican lean, and a negative difference indicates a Democratic lean. <br/> <br/> 

These leans were separated by pre and post enactment of similar laws for each state. A Welch's two tailed T-test was used to determine whether the means of the pre and post leans values were significantly different. <br/> <br/>
"),
            selectInput("state",
                        HTML("<h4> Choose State to view lean data </h4>"),
                        choices = unique(president$state),
                        selected = "Connecticut"
),
            HTML("<h4> <font color=\"#FF0000\"> Red = Republican Lean  </font color=\"#FF0000\"> </col> <br/> <br/> 
                       <font color=\"#41CCEE\"> Blue = Democratic Lean </font color=\"#41CCEE\"> <br/> <br/>
                       Dashed Line = Year of Similar Law Enactment <br/> <br/>
                       Dotted Line = Reference Line for Lean of 0 </h4>")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Graphs",
                         plotlyOutput('presPlot'), # Plot of Presidential Race Leans
                         plotlyOutput('senPlot')), # Plot of Senate Race Leans
                tabPanel("Significance Tests",
                         HTML("<h4> President T-Test results comparing pre and post enactment leans: </h4>"),
                         verbatimTextOutput('pressum'), # T-test of Senate Race Lean Pre and Post Enactment Year
                         HTML("<h4> Senate T-Test results comparing pre and post enactment leans: </h4>"),
                         verbatimTextOutput('sensum'), # T-test of Presidential Race Lean Pre and Post Enactment Year
                         HTML("<h4> Total of All States T-Test results comparing pre and post enactment leans: </h4>"),
                         verbatimTextOutput('totalsum')) # T-test of Senate & Presidential Race Lean Pre and Post Enactment Year
                
            )

        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

    # Plot Rendering for Senate Race Lean
    output$senPlot <- renderPlotly({ 
        
    validate(
         need(input$state != "District of Columbia", "The District of Columbia does not have any Senators.")
        )
        
        # Filtering senate dataset by the reactive input
        SenateCO <- senate %>%
            filter(state == input$state) #Filtering Senate Elections by State
        
        SenateCO_graph <- ggplot(SenateCO, aes(x = year, y = lean, #Graphing political lean by year
                                               color = Color, 
                                               group = NA, 
                                               text = paste0("Winning Candidate: ", candidate), 
                                               xend = lead(year),
                                               yend = lead(lean))) + 
            geom_segment(show.legend = FALSE)+
            ylab("Political Lean")+ #Adding Labels
            xlab("Year")+
            ggtitle("Political Lean of Senate Elections from 1976 to 2018")+
            scale_color_hue(labels = c("Democrat", "Republican"))+
            scale_x_continuous(breaks = seq(min(senate$year), max(senate$year), 
                                            by = 4))+ #Adding Breaks for line segments to have accurate political "color"
            geom_point(show.legend = FALSE)+
            geom_hline(yintercept = 0, 
                       color="black", 
                       linetype = "dotted")+ # Adding in line at y = 0 for easy reference of lean strength
            theme(legend.position = 'none')+ # Removing Legend
            geom_vline(xintercept = SenateCO$enaction, linetype = "longdash") # Vertical Line Representing Similar Law Enactment Year
        
        ggplotly(SenateCO_graph, 
                 tooltip = c("year", "lean", "text"), 
                 originalData = TRUE)%>% #Converting ggplot to interactive plot
            config(displayModeBar = FALSE) # Dropping the display bar

            })

    # Plot Rendering for Presidential Race Lean
    output$presPlot <- renderPlotly({ 
        
                # Filtering senate dataset by the reactive input
                PresidentCO <- president %>%
                    filter(state == input$state) #Filtering Senate Elections by State
                
                PresidentCO_graph <- ggplot(PresidentCO, aes(x = year, y = lean, #Graphing political lean by year
                                                             color = Color, 
                                                             group = NA, 
                                                             text = paste0("Winning Candidate: ", candidate), 
                                                             xend = lead(year),
                                                             yend = lead(lean))) + 
                    geom_segment()+
                    ylab("Political Lean")+ #Adding Labels
                    xlab("Year")+
                    ggtitle("Political Lean of Presidential Elections from 1976 to 2018")+
                    scale_x_continuous(breaks = seq(min(senate$year), max(senate$year), by = 4))+ 
                    #Adding Breaks for line segments to have accurate political "color"
                    geom_point()+
                    geom_hline(yintercept = 0, 
                               color="black", 
                               linetype = "dotted")+ # Adding in line at y = 0 for easy reference of lean strength
                    theme(legend.position = 'none')+ # Removing Legend
                    geom_vline(xintercept = PresidentCO$enaction, linetype = "longdash") # Vertical Line Representing Similar Law Enactment Year
                    
                ggplotly(PresidentCO_graph, 
                         tooltip = c("year", "lean", "text"), 
                         originalData = TRUE)%>% #Converting ggplot to interactive plot
                    config(displayModeBar = FALSE)#Dropping the display bar

    })    
    
    output$sensum <- renderPrint({
        
        # Creating custom error codes for certain states with late enactment years
        validate(
            need(input$state != "District of Columbia", 
                 "The District of Columbia does not have any Senators."),
            
            need(input$state != "Colorado", 
                 "Not enough election datums post enactment to support a T-test"),
            
            need(input$state != "New Mexico", 
                 "Not enough election datums post enactment to support a T-test"),
            
            need(input$state != "North Carolina", 
                 "Not enough election datums post enactment to support a T-test"),
            
            need(input$state != "Utah", 
                 "Not enough election datums post enactment to support a T-test")
        )
        
        # Changing year and enactment from integers to numeric
        senate$year <- as.numeric(senate$year)
        senate$enaction <- as.numeric(senate$enaction)
        
        # Filtering senate data set by state input
        SenateT <- senate %>%
            filter(state == input$state)
        
        #Creating data sets for pre and post enactment years
        pre <- SenateT%>%
            filter(year < enaction)
        
        post <- SenateT%>%
            filter(year >= enaction)
        
        # Performing T-test and creating output
        t.test(pre$lean, post$lean)
    })
    
    output$pressum <- renderPrint({
        
        # Creating custom error codes for certain states with late enactment years
        validate(
            need(input$state != "Illinois", 
                 "Not enough election datums post enactment to support a T-test"),
            
            need(input$state != "Colorado", 
                 "Not enough election datums post enactment to support a T-test"),
            
            need(input$state != "New Mexico", 
                 "Not enough election datums post enactment to support a T-test"),
            
            need(input$state != "North Carolina", 
                 "Not enough election datums post enactment to support a T-test"),
            
            need(input$state != "Utah", 
                 "Not enough election datums post enactment to support a T-test"),
            
            need(input$state != "West Virginia", 
                 "Not enough election datums post enactment to support a T-test")
        )
        
        # Changing year and enactment from integers to numeric
        president$year <- as.numeric(president$year)
        president$enaction <- as.numeric(president$enaction)
        
        # Filtering president data set by state input
        PresidentT <- president %>%
            filter(state == input$state)
        
        #Creating data sets for pre and post enactment years
        Ppre <- PresidentT%>%
            filter(year < enaction)
        
        Ppost <- PresidentT%>%
            filter(year >= enaction)
        
        # Performing T-test and creating output
        t.test(Ppre$lean, Ppost$lean)
    })
    
    output$totalsum <- renderPrint({
        
        # Changing year and enactment from integers to numeric
        data$year <- as.numeric(data$year)
        data$enaction <- as.numeric(data$enaction)
        
        #Creating data sets for pre and post enactment years
        Dpre <- data%>%
            filter(year < enaction)
        
        Dpost <- data%>%
            filter(year >= enaction)
        
        # Performing T-test and creating output
        t.test(Dpre$lean, Dpost$lean)
    })
    
}
# Run the application 
shinyApp(ui = ui, server = server)

