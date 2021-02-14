async function getPage(url) {
    const axios = require('axios');

    return axios({
            url: url,
            method: 'get',
            headers: {
                'Content-Type': 'application/json',
            }
        })
       .then(res => res)
       .catch (err => console.error(err))
}

async function main(url, limit) {
    var pages = await getPage(url)
    var countriesOver = 0;
    //console.log(pages.data)
    for (let i = 1; i <= pages.data.total_pages; i++) {
        var newUrl = url + '&page' + i
        //console.log(newUrl)

        var response = await getPage(newUrl)
        var countries = response.data.data
        //console.log(countries)
        for (let j = 0; j < countries.length; j++) {
            //console.log(countries[j].population)
            if (countries[j].population > limit) countriesOver++
        }
    }
    console.log(countriesOver)
}

// This program checks countries populations and tell's how many countries are over the limit.
// Example: How many countries with 'in' in their name have population over 3000?

var namePrefix = 'in' // example: 'in', 'un', 'ca'
var limit = 3000 // population limit
var url = 'https://jsonmock.hackerrank.com/api/countries/search?name=' + namePrefix

main(url, limit)
