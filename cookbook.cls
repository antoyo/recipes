%
%   Copyright (c) 2014 Boucher, Antoni <bouanto@gmail.com>
%   
%   Permission is hereby granted, free of charge, to any person obtaining a copy of
%   this software and associated documentation files (the "Software"), to deal in
%   the Software without restriction, including without limitation the rights to
%   use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
%   the Software, and to permit persons to whom the Software is furnished to do so,
%   subject to the following conditions:
%   
%   The above copyright notice and this permission notice shall be included in all
%   copies or substantial portions of the Software.
%   
%   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
%   FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
%   COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
%   IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
%   CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%

% TODO: improve display of floating pictures (remove workaround of inserting 15 line numbers as a parameter to the wrapfigure environment).

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cookbook}[2014/07/12 Cookbook]

\LoadClass{report}

\RequirePackage{titlesec}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[francais]{babel}
\RequirePackage{calc}
\RequirePackage[scale=0.8]{geometry}
\RequirePackage{graphicx}
\RequirePackage{ifthen}
\RequirePackage{textcomp}
\RequirePackage{wrapfig}

\title{Livre de recettes}
% Hide the date.
\date{}

% Hide section number.
\setcounter{secnumdepth}{-1}

% Lengths.
\setlength{\parindent}{0in}
\newlength{\cookingpartindent}

% Counters.
\newcounter{preparationtime}
\newcounter{cookingtime}
\newcounter{macerationtime}
\newcounter{totaltime}
\newcounter{heures}
\newcounter{minutes}

% Title Formats.
\titleformat{\section}[display]{\bfseries\centering}{}{}{\fontsize{50}{60}\selectfont}
\titleformat{\subsection}[display]{\bfseries\centering}{}{}{\huge}
\titleformat{\subsubsection}[display]{\bfseries}{}{}{\Large}

% Use bullets in list.
\frenchbsetup{StandardItemLabels}

% New commands.
\newcommand{\plural}[2]{%
    #1 #2%
    \ifthenelse{\lengthtest{#1pt > 1pt}}{s}{}%
}
\newcommand{\modulo}[2]{%
    #1 - #1 / #2 * #2%
}
\newcommand{\settime}[3]{%
    \setcounter{#1}{#2 * 60 + #3}%
}
\newcommand{\showtime}[2]{%
    \ifthenelse{\equal{#1}{0}}{%
        \plural{#2}{minute}%
    }{%
        \ifthenelse{\equal{#2}{0}}{%
            \plural{#1}{heure}%
        }{%
            \plural{#1}{heure} \plural{#2}{minute}%
        }%
    }%
}
\newcommand{\showtimefromminutes}[1]{%
    \setcounter{heures}{#1 / 60}%
    \setcounter{minutes}{\modulo{#1}{60}}%
    \showtime{\theheures}{\theminutes}%
}
\newcommand{\preparationtime}[2][0]{%
    \settime{preparationtime}{#1}{#2}%
    \textbf{Temps de préparation~:} \showtime{#1}{#2}%
}
\newcommand{\cookingtime}[2][0]{%
    \settime{cookingtime}{#1}{#2}%
    \textbf{Temps de cuisson~:} \showtime{#1}{#2}%
}
\newcommand{\macerationtime}[2][0]{%
    \settime{macerationtime}{#1}{#2}%
    \textbf{Temps de macération~:} \showtime{#1}{#2}%
}
\newcommand{\totaltime}[1]{%
    \setcounter{totaltime}{\value{preparationtime} + \value{cookingtime} + \value{macerationtime}}%
    \textbf{Temps total~:} \showtimefromminutes{\thetotaltime}%
}
\newcommand{\portions}[1]{\textbf{Portions~:} #1}
\newcommand{\cookingpart}[1]{\hspace{-\cookingpartindent}%
    \textbf{#1~:}%
}
\newcommand{\image}[2][]{%
    \IfFileExists{#2.jpg}{
        \ifthenelse{\equal{#1}{float}}{%
            \begin{wrapfigure}[15]{r}{0.5\textwidth}%
                \includegraphics[width=0.48\textwidth]{#2}%
            \end{wrapfigure}%
        }%
        {%
            \begin{center}%
                \includegraphics{#2}%
            \end{center}%
        }%
    }%
    {%
    }%
}
\newlength{\recipeboxheight}
\newlength{\recipeimageheight}
\newcommand{\recipe}[3]{%
    \setcounter{preparationtime}{0}%
    \setcounter{cookingtime}{0}%
    \setcounter{macerationtime}{0}%
    \settoheight{\recipeboxheight}{%
        \vbox{%
            \recipetitle{#3}%
            \input{#1/#2}%
            \image{#1/#2}%
        }%
    }%
    %
    \ifthenelse{\lengthtest{\recipeboxheight < \the\textheight}}{%
        \clearpage%
        \recipetitle{#3}%
        \input{#1/#2}%
        \image{#1/#2}%
        \clearpage%
    }%
    {%
        \clearpage%
        \recipetitle{#3}%
        \image[float]{#1/#2}%
        \input{#1/#2}%
        \clearpage%
    }%
}
\newcommand{\recipetitle}[1]{%
    \subsection{#1}%
}
\newcommand{\recipesection}[2]{%
    \clearpage%
    \thispagestyle{empty}%
    \vspace*{\stretch{1}}
    \begin{center}
        \includegraphics[width=128pt, height=128pt]{images/#1}
    \end{center}
    \section{#2}%
    \vspace*{\stretch{1}}
}

% New environments.
\newenvironment{ingredients}%
{\subsubsection{Ingrédients}%
    \setlength{\cookingpartindent}{11pt}%
    \begin{itemize}%
    \addtolength{\leftskip}{10mm}%
}{%
    \end{itemize}%
}
\newenvironment{steps}%
{\subsubsection{Étapes}%
    \setlength{\cookingpartindent}{13pt}%
    \begin{enumerate}%
    \addtolength{\leftskip}{10mm}%
}{%
    \end{enumerate}%
}

\endinput
